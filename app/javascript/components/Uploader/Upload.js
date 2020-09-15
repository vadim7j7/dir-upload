import React, { useState, useCallback } from 'react';

import { Uploader } from '../../utils/utils';

function uploadFile(file) {
  const uploader = new Uploader(file);
  uploader.uploadFile();
}

const Upload = ({ files }) => {
  const [loading, setLoading] = useState(false);

  const sendToServer = useCallback(() => {
    setLoading(true);

    Array.from(files).forEach(file => uploadFile(file))
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
