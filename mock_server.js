const { WebSocketServer } = require('ws');
const wss = new WebSocketServer({ port: 8080 });

const matches = [
  { id: 'match_1', home: 'Arsenal',   away: 'Chelsea',    homeScore: 0, awayScore: 0, minute: 0, status: 'LIVE' },
  { id: 'match_2', home: 'Barcelona', away: 'Real Madrid',homeScore: 1, awayScore: 1, minute: 34, status: 'LIVE' },
  { id: 'match_3', home: 'PSG',       away: 'Lyon',       homeScore: 0, awayScore: 0, minute: 0, status: 'UPCOMING' },
  { id: 'match_4', home: 'Juventus',  away: 'AC Milan',   homeScore: 2, awayScore: 1, minute: 90, status: 'FINISHED' },
];

const eventTypes = ['GOAL', 'YELLOW_CARD', 'RED_CARD', 'SUBSTITUTION', 'MINUTE_UPDATE'];

function randomEvent() {
  const match  = matches[Math.floor(Math.random() * 2)]; // only LIVE matches
  const type   = eventTypes[Math.floor(Math.random() * eventTypes.length)];
  const side   = Math.random() > 0.5 ? 'home' : 'away';

  match.minute = Math.min(match.minute + 1, 90);

  if (type === 'GOAL') { match[side + 'Score']++; }

  return {
    type,
    matchId:  match.id,
    minute:   match.minute,
    team:     side === 'home' ? match.home : match.away,
    player:   'Player ' + Math.floor(Math.random() * 30 + 1),
    homeScore: match.homeScore,
    awayScore: match.awayScore,
    status:   match.status,
    timestamp: new Date().toISOString(),
  };
}

wss.on('connection', (ws) => {
  console.log('Client connected');

  // Send full match list immediately on connect
  ws.send(JSON.stringify({ type: 'SNAPSHOT', matches }));

  // Send a random event every 2 seconds
  const interval = setInterval(() => {
    if (ws.readyState === ws.OPEN) {
      ws.send(JSON.stringify(randomEvent()));
    }
  }, 2000);

  ws.on('close', () => { clearInterval(interval); console.log('Client disconnected'); });
});

console.log('Mock server running on ws://localhost:8080');
