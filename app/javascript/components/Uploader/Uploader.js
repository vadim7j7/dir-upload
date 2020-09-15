import React, { useState } from 'react';

import Dropzone from './Dropzone';
import Preview from './Preview';
import Upload from './Upload';

const Uploader = () => {
  const [files, setFiles] = useState([]);

  return (
    <div className="uploader">
      <Dropzone onAcceptedFiles={setFiles} />
      <Preview files={files} />
      <Upload files={files} />
    </div>
  );
};

export default Uploader;
