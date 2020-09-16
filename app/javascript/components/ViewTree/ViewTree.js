import React, { useMemo, useState } from 'react';
import Tree from 'antd/es/tree';

const ViewTree = () => {
  const [treeData, setTreeData] = useState([]);

  useMemo(() => {
    fetch('/api/directories')
      .then(response => response.json())
      .then(({ data }) => {
        setTreeData(data);
      })
  }, []);

  return (
    <div className="view-tree">
      <Tree
        showLine
        treeData={treeData}
      />
    </div>
  );
};

export default ViewTree
