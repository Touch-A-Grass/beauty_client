part of 'order_details_widget.dart';

class _OrderRatingView extends StatelessWidget {
  final OrderReview review;

  const _OrderRatingView(this.review);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RatingView(rating: review.rating, starSize: 24),
          if (review.comment.isNotEmpty) Text(review.comment, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _OrderNewRatingView extends StatefulWidget {
  final ValueChanged<OrderReview> onSubmit;
  final bool isLoading;

  const _OrderNewRatingView(this.onSubmit, this.isLoading);

  @override
  State<_OrderNewRatingView> createState() => _OrderNewRatingViewState();
}

class _OrderNewRatingViewState extends State<_OrderNewRatingView> {
  final rating = ValueNotifier(0);
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: AnimatedSize(
        duration: Duration(milliseconds: 250),
        alignment: Alignment.topCenter,
        child: AnimatedBuilder(
          animation: Listenable.merge([rating, commentController]),
          builder:
              (context, __) => Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RatingView(
                    rating: rating.value,
                    starSize: 48,
                    onRatingChanged: widget.isLoading ? null : (value) => rating.value = value,
                  ),
                  if (rating.value > 0) ...[
                    TextFormField(
                      enabled: !widget.isLoading,
                      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 400),
                      controller: commentController,
                      decoration: InputDecoration(labelText: 'Комментарий'),
                      minLines: 1,
                      maxLines: 10,
                      maxLength: 2000,
                    ),
                    Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: widget.isLoading ? null : () => rating.value = 0,
                            child: Text(S.of(context).cancel),
                          ),
                        ),
                        Expanded(
                          child: FilledButton(
                            onPressed:
                                widget.isLoading
                                    ? null
                                    : () => widget.onSubmit(
                                      OrderReview(rating: rating.value, comment: commentController.text.trim()),
                                    ),
                            child: Text(S.of(context).send),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
        ),
      ),
    );
  }
}
