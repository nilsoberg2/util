classdef DSSMat
    
    properties (Hidden = true, SetAccess = private)
        handle;
        isOpened;
    end
    
    methods
        % Constructor
        function this = DSSMat()
            dssLibPath = [pwd '\' computer('arch') '\DSSLib.dll'];
            disp(['Loading DSS library from ' dssLibPath]);
            NET.addAssembly(dssLibPath);
            this.handle = DSS.DSSInterface();
            this.isOpened = 1;
        end
        % Destructor
        function delete(this)
            if (this.handle < 0)
                error('Invalid DSS handle')
            end
            this.handle.Close();
        end
        % 
        function status = open(this, dssFile)
            if (this.handle < 0)
                error('Invalid DSS handle')
            end
            this.isOpened = this.handle.Open(dssFile);
            if (~this.isOpened)
                this.delete();
                error(['Error opening DSS file ' dssFile]);
            end
            status = 1;
        end
        
        function paths = catalog(this)
            if (this.handle < 0)
                error('Invalid DSS handle')
            end
            paths = {};
            list = this.handle.Catalog();
            for i = 1 : list.Count
                paths{i} = char(list.Item(i - 1));
            end
        end
        
        function dataset = read(this, dataPath)
            %Time.Ticks / 10000000 / 3600 / 24 + 367
            span = this.handle.Read(dataPath);
            dataset = zeros(span.Count, 2);
            for i = 1 : span.Count
                dataset(i, 1) = span.Item(i - 1).Time.Ticks / 10000000 / 3600 / 24 + 367;
                dataset(i, 2) = span.Item(i - 1).Value;
            end
        end
    end
end
