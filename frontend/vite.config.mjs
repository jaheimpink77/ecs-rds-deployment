import { defineConfig } from 'vite'
import reactRefresh from '@vitejs/plugin-react-refresh'

// Where the Django API lives. Locally that's the dev server on :8000; under
// docker-compose the frontend container reaches it as the `backend` service.
const apiTarget = process.env.API_PROXY_TARGET || 'http://localhost:8000'

// Forward /api to Django so the browser only ever talks to this origin, which
// keeps CORS out of the picture. Django already mounts its routes under /api,
// so no rewrite. changeOrigin is left off on purpose: Django's ALLOWED_HOSTS
// only lists localhost/127.0.0.1, so the original Host header has to survive.
const proxy = {
  '/api': {
    target: apiTarget,
    changeOrigin: false,
  },
}

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [reactRefresh()],
  server: {
    proxy,
  },
  // `vite preview` serves the production build with the same proxy rules, so
  // the built app behaves like the dev server instead of 404ing on /api.
  preview: {
    host: true,
    port: 3000,
    proxy,
  },
})
