            if (article.featuredImageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Semantics(
                  label: article.title,
                  child: CachedNetworkImage(
                    imageUrl: article.featuredImageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Theme.of(context).colorScheme.surface,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
              ),
            ), 