enum AppRoute {
  login(path: '/login', name: 'login'),
  home(path: '/home', name: 'home'),
  markets(path: '/markets', name: 'markets'),
  portfolio(path: '/portfolio', name: 'portfolio'),
  settings(path: '/settings', name: 'settings');

  const AppRoute({required this.path, required this.name});

  final String path;
  final String name;
}
