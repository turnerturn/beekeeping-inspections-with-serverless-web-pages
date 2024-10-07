exports.handler = async (event) => {
    const htmlContent = `
    <!DOCTYPE html>
    <html>
    <head>
        <title>Publish RAC Ordering</title>
    </head>
    <body>
        <h1>Published RAC Ordering</h1>
        <p>The RAC ordering has been published successfully.</p>
    </body>
    </html>`;
    return {
        statusCode: 200,
        headers: {
            'Content-Type': 'text/html',
        },
        body: htmlContent,
    };
};
