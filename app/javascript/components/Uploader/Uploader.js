import React, { useState, useCallback } from 'react';

import Dropzone from './Dropzone';
import Preview from './Preview';
import Upload from './Upload';

const Uploader = () => {
  const [items, setItems] = useState([]);

  const acceptedFiles = useCallback(files => {
    setItems(files.map(file => ({
      file: file,
      uploadProgress: null,
    })))
  }, []);

  const uploadProgress = useCallback((index, percent) => {
    const tmp = [...items]
    tmp[index].uploadProgress = percent;
    setItems(tmp);
  }, [items]);

  return (
    <div className="uploader">
      <Dropzone onAcceptedFiles={acceptedFiles} />
      <Preview items={items} />
      <Upload items={items} onUploadProgress={uploadProgress} />
    </div>
  );
};

export default Uploader;
