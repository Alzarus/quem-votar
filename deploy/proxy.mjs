import http from 'http';

const PORT = parseInt(process.env.PORT || '3000', 10);
const TSE_ORIGIN = 'https://divulgacandcontas.tse.jus.br';

const FORWARD_HEADERS = {
  'User-Agent':
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36',
  Referer: 'https://divulgacandcontas.tse.jus.br/divulga/',
  Origin: 'https://divulgacandcontas.tse.jus.br',
  Accept: 'application/json, text/plain, */*',
  'Accept-Language': 'pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7',
};

const server = http.createServer(async (req, res) => {
  if (req.method === 'OPTIONS') {
    res.writeHead(204, {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, OPTIONS',
      'Access-Control-Allow-Headers': '*',
    });
    return res.end();
  }

  const targetUrl = `${TSE_ORIGIN}${req.url}`;
  try {
    const upstream = await fetch(targetUrl, {
      method: req.method,
      headers: FORWARD_HEADERS,
    });

    const responseHeaders = {
      'Content-Type': upstream.headers.get('content-type') || 'application/json;charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, OPTIONS',
      'Cache-Control': 'public, max-age=900',
    };

    res.writeHead(upstream.status, responseHeaders);
    const arrayBuffer = await upstream.arrayBuffer();
    res.end(Buffer.from(arrayBuffer));
  } catch (err) {
    res.writeHead(502, {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    });
    res.end(JSON.stringify({ error: err.message, targetUrl }));
  }
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`[TSE Micro-Proxy] Escutando na porta ${PORT}`);
});
