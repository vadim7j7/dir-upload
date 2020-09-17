import React from 'react';
import 'antd/dist/antd.css';

import Uploader from '../Uploader';
import ViewTree from '../ViewTree';

const FileManager = () => (
  <div>
    <Uploader />
    <ViewTree />
  </div>
);

export default FileManager;
