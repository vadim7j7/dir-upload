import React, { useCallback } from 'react';
import Button from 'antd/es/button';

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
      <Button type="primary" onClick={sendToServer}>
        Upload
      </Button>
    </div>
  );
};

export default Upload;
