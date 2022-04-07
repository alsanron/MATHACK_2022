classdef main_class < matlab.System
    % untitled Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties

    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)
        mobile_obj;
        model_knn;
        time_step = 0.01; % s
        interval_acc = 0.01; % s
        interval_vel = 2; % s
        threshold_acceleration = 20; % m/s2
        n_samples_vel;
        n_samples_acc;
        time;
        velocity;
        acceleration;
    end

    methods(Access = protected)
        function setupImpl(obj)
            obj.n_samples_vel = ceil(obj.interval_vel * (1 / obj.time_step));
            obj.velocity = zeros(obj.n_samples_vel, 1);
            obj.n_samples_acc = ceil(obj.interval_acc * (1 / obj.time_step));
            obj.acceleration = zeros(obj.n_samples_acc, 1);

            obj.time = 0;

            load('Data/model.mat');
            obj.model_knn = model;

            addpath('Code');
            addpath('Code/telegram_functions');

            % Enables the mobiles to log and stream data
            obj.mobile_obj = mobiledev;
            obj.mobile_obj.SampleRate = 100; %Sets sample rate at which device will acquire the data
            obj.mobile_obj.AngularVelocitySensorEnabled = 1;
            obj.mobile_obj.OrientationSensorEnabled = 1;
            obj.mobile_obj.AccelerationSensorEnabled = 1;
            obj.mobile_obj.PositionSensorEnabled = 1;
            obj.mobile_obj.MagneticSensorEnabled = 1;
            obj.mobile_obj.Logging = 1; % start the transmission of data from all selected sensors
        end

        function [t, acc, vel, lat, lon, state, shock, Amax] = stepImpl(obj)
            obj.time = obj.time + obj.time_step;
            t = obj.time;
            acc = sqrt(sum(obj.mobile_obj.Acceleration.^2, 2));
            vel = obj.mobile_obj.Speed;
            lat = obj.mobile_obj.Latitude;
            lon = obj.mobile_obj.Longitude;

            if isempty(acc)
                acc = 0;
            else
                acc = acc - 9.81;
            end

            if isempty(vel)
                vel = 0;
            end

            if isempty(lat)
                lat = 0;
            end

            if isempty(lon)
                lon = 0;
            end

            obj.updateData(acc, vel);

            state = obj.getState();

            [shock, Amax] = obj.isShock();
            if shock
                obj.sendAlert(state, Amax, lat, lon);
            end
            fprintf('State: %s , Shock: %d , Amax: %.2f\r', state, shock, Amax);
            pause(obj.time_step);
        end

        function updateData(obj, acc, vel)
            obj.velocity(1:(end - 1)) = obj.velocity(2:end);
            obj.velocity(end) = vel;

            obj.acceleration(1:(end - 1)) = obj.acceleration(2:end);
            obj.acceleration(end) = acc;
        end

        function state = getState(obj)
            % state → State of the sensor based in its velocity
            Vmean = mean(obj.velocity);
            state = char(predict(obj.model_knn, Vmean));
        end

        function [shock, Amax] = isShock(obj)
            % shock → Indicates a shock in the acceleration data (boolean)
            % Amax → Maximum acceleration in the samples (m/s2)
            Amax = max(obj.acceleration);
            if Amax > obj.threshold_acceleration
                shock = true;
            else
                shock = false;
            end
        end

        function sendAlert(obj, state, Amax, lat, lon)
            % state → State of the sensor based in its velocity
            % Amax → Maximum acceleration of the shock (m/s2)
            % lat → Latitude (deg)
            % lon → Longitude (deg)
            BotToken = '5171014369:AAGqkyeKK0Zj8EZbPiaH_DrZ_Q7U-b04C9k';
            ChatID = '950714104';
            ShockBot = telegram_bot(BotToken);

            mapsURL = ['https://www.google.es/maps/dir//' sprintf('%.7f',lat)...
                ',' sprintf('%.7f',lon) '/@' sprintf('%.7f',lat) ',' sprintf('%.7f',lon) ',16z?hl=es'];

            figure('visible', 'off');
            geoplot(lat,lon,'.r','MarkerSize',30)
            geolimits([lat-0.001 lat+0.001],[lon-0.001 lon+0.001])
            geobasemap streets
            saveas(gcf,'map.png')

            msg = ['System detected a <b>' sprintf('%.2f',Amax/9.81) 'g shock</b> while '...
                'user was <b>' state '</b>. Google Maps: ' mapsURL];

            ShockBot.sendPhoto(ChatID, 'photo_file', 'map.png',... % photo
                'usepm', true,... % show progress monitor
                'caption', msg,'parse_mode','HTML'); %caption of photo
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end

        function [o1, o2, o3, o4, o5, o6, o7, o8] = getOutputSizeImpl(obj)
            % Return size for each output port
            o1 = [1 1];
            o2 = [1 1];
            o3 = [1 1];
            o4 = [1 1];
            o5 = [1 1];
            o6 = [1 1];
            o7 = [1 1];
            o8 = [1 1];
        end

        function [o1, o2, o3, o4, o5, o6, o7, o8] = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            o1 = "double";
            o2 = "double";
            o3 = "double";
            o4 = "double";
            o5 = "double";
            o6 = "string";
            o7 = "boolean";
            o8 = "double";
        end

        function [o1, o2, o3, o4, o5, o6, o7, o8] = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            o1 = false;
            o2 = false;
            o3 = false;
            o4 = false;
            o5 = false;
            o6 = false;
            o7 = false;
            o8 = false;
        end

        function [o1, o2, o3, o4, o5, o6, o7, o8] = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            o1 = true;
            o2 = true;
            o3 = true;
            o4 = true;
            o5 = true;
            o6 = true;
            o7 = true;
            o8 = true;
        end
    end
end
