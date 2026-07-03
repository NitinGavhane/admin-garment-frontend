// Custom Flutter web bootstrap.
//
// Pins the CanvasKit renderer to the locally-bundled copy (served under
// "canvaskit/") instead of the default gstatic CDN. Without this, debug runs
// and any environment that cannot reach www.gstatic.com render a blank white
// page with no Dart error, because the engine never downloads its renderer.
//
// NOTE: the loader tokens below are string-substituted by the Flutter tool at
// build/run time. Keep each on its own line and never name them inside a
// comment, or their (multi-line) replacement will break out of the comment.
{{flutter_js}}
{{flutter_build_config}}
_flutter.loader.load({
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}},
  },
  config: {
    // Relative to <base href> so it also works when deployed under a subpath.
    canvasKitBaseUrl: "canvaskit/",
  },
});
