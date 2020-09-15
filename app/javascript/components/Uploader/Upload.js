import React, { useCallback } from 'react';

import { Uploader } from '../../utils/utils';

function uploadFile(file, index, onUploadProgress) {
  const uploader = new Uploader(file, percent => {
    onUploadProgress(index, percent);
  });
  uploader.uploadFile();
}

const Upload = ({ items, onUploadProgress }) => {
  const sendToServer = useCallback(() => {
    items.forEach((item, index) => uploadFile(item.file, index, onUploadProgress));
  }, [items]);

  return (
    <div className="upload">
      <button onClick={sendToServer}>
        Upload
      </button>
    </div>
  );
};

export default Upload;
