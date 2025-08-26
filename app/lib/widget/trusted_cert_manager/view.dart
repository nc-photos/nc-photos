part of '../trusted_cert_manager.dart';

class _InitView extends StatelessWidget {
  const _InitView();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topCenter,
      child: LinearProgressIndicator(),
    );
  }
}

class _ContentView extends StatelessWidget {
  const _ContentView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 4),
        Expanded(
          child: _BlocSelector<List<CertInfo>>(
            selector: (state) => state.certs,
            builder:
                (context, certs) =>
                    certs.isEmpty
                        ? const _EmptyView()
                        : ListView.builder(
                          itemCount: certs.length,
                          itemBuilder: (_, index) {
                            final item = certs[index];
                            return Dismissible(
                              key: Key(item.sha1),
                              onDismissed: (direction) {
                                context.addEvent(_RemoveCert(item));
                              },
                              background: Container(
                                color: Theme.of(context).colorScheme.error,
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Icon(
                                    Icons.delete_outline,
                                    color:
                                        Theme.of(context).colorScheme.onError,
                                  ),
                                ),
                              ),
                              secondaryBackground: Container(
                                color: Theme.of(context).colorScheme.error,
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Icon(
                                    Icons.delete_outline,
                                    color:
                                        Theme.of(context).colorScheme.onError,
                                  ),
                                ),
                              ),
                              child: _ItemView(item),
                            );
                          },
                        ),
          ),
        ),
      ],
    );
  }
}

class _ItemView extends StatelessWidget {
  const _ItemView(this.cert);

  @override
  Widget build(BuildContext context) {
    final now = clock.now();
    final isExpired = now.isAfter(cert.endValidity);
    return ListTile(
      title: Text(cert.host),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.tag, size: 16),
              const SizedBox(width: 4),
              Expanded(child: Text(cert.sha1)),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 16),
              const SizedBox(width: 4),
              Text(
                DateFormat.yMMMd(
                  Localizations.localeOf(context).languageCode,
                ).format(cert.endValidity.toLocal()),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.domain_verification_outlined, size: 16),
              const SizedBox(width: 4),
              Expanded(child: Text(cert.subject)),
            ],
          ),
        ],
      ),
      tileColor:
          isExpired ? Theme.of(context).colorScheme.errorContainer : null,
    );
  }

  final CertInfo cert;
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return EmptyListIndicator(
      icon: Icons.security,
      text: L10n.global().listEmptyText,
    );
  }
}

class _AccountDialog extends StatelessWidget {
  const _AccountDialog();

  @override
  Widget build(BuildContext context) {
    return ValueStreamBuilder(
      stream: context.bloc.prefController.accounts,
      builder: (context, snapshot) {
        final data =
            snapshot.requireData
                .where((a) => a.scheme == "https")
                .distinctIf((a, b) => a.url == b.url, (a) => a.url.hashCode)
                .toList();
        return SimpleDialog(
          title: Text(L10n.global().trustedCertManagerSelectServer),
          children:
              data.isEmpty
                  ? [
                    ListTile(
                      title: Text(
                        L10n.global().trustedCertManagerNoHttpsServerError,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                    ),
                  ]
                  : data
                      .map(
                        (e) => SimpleDialogOption(
                          onPressed: () {
                            Navigator.of(context).pop(e);
                          },
                          child: Text(e.url),
                        ),
                      )
                      .toList(),
        );
      },
    );
  }
}
