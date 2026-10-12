FROM node:20-alpine

ENV NODE_ENV=production \
    PORT=3000

WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev && npm cache clean --force
COPY server.js .

# "node" user in the official image has UID 1000
USER 1000

EXPOSE 3000
CMD ["node", "server.js"]
