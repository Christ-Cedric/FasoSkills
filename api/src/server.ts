import http from 'http';
import { createApp } from './app.js';
import { env } from './config/env.js';
import { connectDatabase } from './config/database.js';
import { wsManager } from './core/websocket/ws-server.js';

async function bootstrap() {
  await connectDatabase();

  const app = createApp();
  const server = http.createServer(app);

  // Initialize WebSocket server attached to HTTP server
  wsManager.init(server);

  server.listen(env.PORT, () => {
    console.log(`🚀 FasoSkills API running on http://localhost:${env.PORT}`);
    console.log(` WebSocket available on ws://localhost:${env.PORT}/ws`);
  });
}

bootstrap().catch((err) => {
  console.error('Failed to start server:', err);
  process.exit(1);
});
