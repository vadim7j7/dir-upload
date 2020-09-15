import React, { useCallback } from 'react';

import { Uploader } from '../../utils/utils';

function uploadFile(file) {
  const uploader = new Uploader(file);
  uploader.uploadFile();
}

const Upload = ({ files }) => {
  const sendToServer = useCallback(() => {
    files.forEach(file => uploadFile(file));
  }, [files]);

  return (
    <div className="upload">
      <button onClick={sendToServer}>
        Upload
      </button>
    </div>
  );
};

export default Upload;
