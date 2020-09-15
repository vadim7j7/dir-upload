import React, { useState, useCallback } from 'react';

const Upload = ({ files }) => {
  const [loading, setLoading] = useState(false);

  const sendToServer = useCallback(() => {
    setLoading(true);
  }, [files]);

  return (
    <div className="upload">
      <button disabled={loading} onClick={sendToServer}>
        Upload{loading ? '...' : ''}
      </button>
    </div>
  );
};

export default Upload;
