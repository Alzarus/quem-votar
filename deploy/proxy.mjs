import http from 'http';
import { Readable } from 'stream';

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

  let pathname = req.url || '/';
  // Normalizacao defensiva: se a rota comeca com /divulga/rest/ mas nao contem v1 nem arquivo, insere v1
  if (
    pathname.startsWith('/divulga/rest/') &&
    !pathname.startsWith('/divulga/rest/v1/') &&
    !pathname.startsWith('/divulga/rest/arquivo/')
  ) {
    pathname = pathname.replace('/divulga/rest/', '/divulga/rest/v1/');
  }

  const targetUrl = `${TSE_ORIGIN}${pathname}`;
  const startTime = Date.now();

  try {
    const upstream = await fetch(targetUrl, {
      method: req.method,
      headers: FORWARD_HEADERS,
    });

    const duration = Date.now() - startTime;
    console.log(`[PROXY] ${req.method} ${pathname} -> HTTP ${upstream.status} (${duration}ms)`);

    const responseHeaders = {
      'Content-Type': upstream.headers.get('content-type') || 'application/json;charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, OPTIONS',
      'Cache-Control': upstream.ok ? 'public, max-age=900' : 'no-cache, no-store',
    };

    res.writeHead(upstream.status, responseHeaders);
    if (upstream.body) {
      Readable.fromWeb(upstream.body).pipe(res);
    } else {
      res.end();
    }
  } catch (err) {
    const duration = Date.now() - startTime;
    console.error(`[PROXY ERRO] ${req.method} ${pathname} -> ${err.message} (${duration}ms)`);
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
