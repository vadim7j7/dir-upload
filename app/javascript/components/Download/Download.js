import React, { useCallback } from 'react';
import axios from 'axios';
import Button from 'antd/es/button';

const Download = ({ disabled, keys }) => {
  const run = useCallback(() => {
    axios
      .post('/api/directories/archive', { keys })
      .then(() => {})
      .catch(() => {});
  }, [keys]);

  return (
    <div className="download">
      <Button disabled={disabled} type="primary" onClick={run}>
        Download
      </Button>
    </div>
  );
};

export default Download;
