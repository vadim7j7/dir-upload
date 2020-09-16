import React, { useMemo, useState } from 'react';
import Tree from 'antd/es/tree';
import Spin from 'antd/es/spin';

const ViewTree = () => {
  const [loading, setLoading] = useState(true);
  const [treeData, setTreeData] = useState([]);

  useMemo(() => {
    fetch('/api/directories')
      .then(response => response.json())
      .then(({ data }) => {
        setTreeData(data);
        setLoading(false);
      })
  }, []);

  return (
    <div className="view-tree">
      {loading ? (
        <div style={{ textAlign: 'center' }}>
          <Spin size="large" />
        </div>
      ) : (
        <Tree
          showLine
          defaultExpandAll
          treeData={treeData}
        />
      )}
    </div>
  );
};

export default ViewTree
