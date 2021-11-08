%% resolve o problema do turbojet ideial
%function out = resolve(func, input, eixoX_, curvas_,varargin)
function out = resolve_(func, input, varargin)
    function x = notNumber(x)
        if x == 0
            x = NaN;
        end
    end
    
    
    if numel(varargin) > 2 && isfield(input,varargin{3})
        in = input;
        for i=1:length(input.(varargin{3}))
            try 
                arg = varargin{4};
            catch
                arg = '';
            end
            in.(varargin{3}) = input.(varargin{3})(i);
            out(i) = resolve_(func, in, varargin{1}, varargin{2}, arg);
        end
    else
        %%
        % copia o struct de entrada
        in = input;
        try
            eixoX = input.(varargin{1})';
        catch
            eixoX = 1;
        end
        
        try 
            curvas = input.(varargin{2});
        catch
            curvas = '1';
        end
        
        fn = fieldnames(input);
        for j=1:length(curvas)
            if length(curvas) == 1
                for k=1:numel(fn)
                      in.(fn{k}) = input.(fn{k})(j);
                end
            else
                for k=1:numel(fn)
                      in.(fn{k}) = input.(fn{k})(1);
                      
                end
                in.(varargin{2}) = input.(varargin{2})(j);
            end
            
            %in.(varargin{2}) = input.(varargin{2})(j);
            for i=1:length(eixoX)
                %input = setfield(input, varargin{1}, eixoX(i));
                in.(varargin{1}) = input.(varargin{1})(i);
                output(i,j) = func(in);

                %% limpa vetor a partir das partes negativas
                fno = fieldnames(output);
                flag = false;
                if ismember('trunca',varargin)
                    for k=1:numel(fno)
                        if output(i,j).(fno{k}) < 0 || flag || imag(output(i,j).(fno{k}))
                            output(i,j).(fno{k}) = NaN;
                            flag = true;
                        end
                        if imag(output(i,j).(fno{k}))
                            output(i,j).(fno{k}) = NaN;
                        end
                    end
                end
            end
        end

        for k=1:numel(fno)
            out.(fno{k}) = reshape([output.(fno{k})], size(output));       
              if max(max(~~imag(out.(fno{k})))) == 1
                  out.(fno{k}) = arrayfun(@notNumber,(~imag(out.(fno{k})).*out.(fno{k})));
              end
        end
    end
end