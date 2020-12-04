echo 'START VIDEOS'
echo 'testing  --input-res 640x360 --fps 24 -o test.mp4 ./inputs/original_videos_Gaming_360P_Gaming_360P-56fe.mkv'
x264  --input-res 640x360 --fps 24 -o test.mp4 ./inputs/original_videos_Gaming_360P_Gaming_360P-56fe.mkv
echo 'testing  --input-res 624x464 --fps 25 -o test.mp4 ./inputs/original_videos_Sports_360P_Sports_360P-4545.mkv'
x264  --input-res 624x464 --fps 25 -o test.mp4 ./inputs/original_videos_Sports_360P_Sports_360P-4545.mkv
echo 'testing  --input-res 720x480 --fps 15.42 -o test.mp4 ./inputs/original_videos_Animation_480P_Animation_480P-087e.mkv'
x264  --input-res 720x480 --fps 15.42 -o test.mp4 ./inputs/original_videos_Animation_480P_Animation_480P-087e.mkv
echo 'testing  --input-res 480x360 --fps 30 -o test.mp4 ./inputs/original_videos_CoverSong_360P_CoverSong_360P-5d20.mkv'
x264  --input-res 480x360 --fps 30 -o test.mp4 ./inputs/original_videos_CoverSong_360P_CoverSong_360P-5d20.mkv
echo 'testing  --input-res 640x360 --fps 25 -o test.mp4 ./inputs/original_videos_Lecture_360P_Lecture_360P-114f.mkv'
x264  --input-res 640x360 --fps 25 -o test.mp4 ./inputs/original_videos_Lecture_360P_Lecture_360P-114f.mkv
echo 'testing  --input-res 640x360 --fps 30 -o test.mp4 ./inputs/original_videos_MusicVideo_360P_MusicVideo_360P-5699.mkv'
x264  --input-res 640x360 --fps 30 -o test.mp4 ./inputs/original_videos_MusicVideo_360P_MusicVideo_360P-5699.mkv
echo 'testing  --input-res 640x360 --fps 25 -o test.mp4 ./inputs/original_videos_LiveMusic_360P_LiveMusic_360P-1d94.mkv'
x264  --input-res 640x360 --fps 25 -o test.mp4 ./inputs/original_videos_LiveMusic_360P_LiveMusic_360P-1d94.mkv
echo 'testing  --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv'
x264  --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo 'testing  --input-res 640x360 --fps 24 -o test.mp4 ./inputs/original_videos_Gaming_360P_Gaming_360P-56fe.mkv'
x265  --input-res 640x360 --fps 24 -o test.mp4 ./inputs/original_videos_Gaming_360P_Gaming_360P-56fe.mkv
echo 'testing  --input-res 624x464 --fps 25 -o test.mp4 ./inputs/original_videos_Sports_360P_Sports_360P-4545.mkv'
x265  --input-res 624x464 --fps 25 -o test.mp4 ./inputs/original_videos_Sports_360P_Sports_360P-4545.mkv
echo 'testing  --input-res 720x480 --fps 15.42 -o test.mp4 ./inputs/original_videos_Animation_480P_Animation_480P-087e.mkv'
x265  --input-res 720x480 --fps 15.42 -o test.mp4 ./inputs/original_videos_Animation_480P_Animation_480P-087e.mkv
echo 'testing  --input-res 480x360 --fps 30 -o test.mp4 ./inputs/original_videos_CoverSong_360P_CoverSong_360P-5d20.mkv'
x265  --input-res 480x360 --fps 30 -o test.mp4 ./inputs/original_videos_CoverSong_360P_CoverSong_360P-5d20.mkv
echo 'testing  --input-res 640x360 --fps 25 -o test.mp4 ./inputs/original_videos_Lecture_360P_Lecture_360P-114f.mkv'
x265  --input-res 640x360 --fps 25 -o test.mp4 ./inputs/original_videos_Lecture_360P_Lecture_360P-114f.mkv
echo 'testing  --input-res 640x360 --fps 30 -o test.mp4 ./inputs/original_videos_MusicVideo_360P_MusicVideo_360P-5699.mkv'
x265  --input-res 640x360 --fps 30 -o test.mp4 ./inputs/original_videos_MusicVideo_360P_MusicVideo_360P-5699.mkv
echo 'testing  --input-res 640x360 --fps 25 -o test.mp4 ./inputs/original_videos_LiveMusic_360P_LiveMusic_360P-1d94.mkv'
x265  --input-res 640x360 --fps 25 -o test.mp4 ./inputs/original_videos_LiveMusic_360P_LiveMusic_360P-1d94.mkv
echo 'testing  --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv'
x265  --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo 'END VIDEOS'
echo 'START VALUES OPTIONS'
echo '--aud'
x264 --aud --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--constrained-intra'
x264 --constrained-intra --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--intra-refresh'
x264 --intra-refresh --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--no-asm'
x264 --no-asm --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--slow-firstpass'
x264 --slow-firstpass --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--weightb'
x264 --weightb --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--no-weightb'
x264 --no-weightb --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aud'
x265 --aud --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--constrained-intra'
x265 --constrained-intra --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--intra-refresh'
x265 --intra-refresh --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--no-asm'
x265 --no-asm --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--slow-firstpass'
x265 --slow-firstpass --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--weightb'
x265 --weightb --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--no-weightb'
x265 --no-weightb --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo 'END VALUES OPTIONS'
echo 'START ARGUMENTS OPTIONS'
echo '--aq-strength 0.0'
x264 --aq-strength 0.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-strength 0.5'
x264 --aq-strength 0.5 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-strength 1.0'
x264 --aq-strength 1.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-strength 1.5'
x264 --aq-strength 1.5 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-strength 2.0'
x264 --aq-strength 2.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-strength 2.5'
x264 --aq-strength 2.5 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-strength 3.0'
x264 --aq-strength 3.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ipratio 1.0'
x264 --ipratio 1.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ipratio 1.1'
x264 --ipratio 1.1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ipratio 1.2'
x264 --ipratio 1.2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ipratio 1.3'
x264 --ipratio 1.3 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ipratio 1.4'
x264 --ipratio 1.4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ipratio 1.5'
x264 --ipratio 1.5 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ipratio 1.6'
x264 --ipratio 1.6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--pbratio 1.0'
x264 --pbratio 1.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--pbratio 1.1'
x264 --pbratio 1.1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--pbratio 1.2'
x264 --pbratio 1.2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--pbratio 1.3'
x264 --pbratio 1.3 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--pbratio 1.4'
x264 --pbratio 1.4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 0.2'
x264 --psy-rd 0.2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 0.4'
x264 --psy-rd 0.4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 0.6'
x264 --psy-rd 0.6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 0.8'
x264 --psy-rd 0.8 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 1.0'
x264 --psy-rd 1.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 1.2'
x264 --psy-rd 1.2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 1.4'
x264 --psy-rd 1.4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 1.6'
x264 --psy-rd 1.6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 1.8'
x264 --psy-rd 1.8 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 2.0'
x264 --psy-rd 2.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 2.2'
x264 --psy-rd 2.2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 2.4'
x264 --psy-rd 2.4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 2.6'
x264 --psy-rd 2.6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 2.8'
x264 --psy-rd 2.8 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 3.0'
x264 --psy-rd 3.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 3.2'
x264 --psy-rd 3.2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 3.4'
x264 --psy-rd 3.4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 3.6'
x264 --psy-rd 3.6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 3.8'
x264 --psy-rd 3.8 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 4.0'
x264 --psy-rd 4.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 4.2'
x264 --psy-rd 4.2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 4.4'
x264 --psy-rd 4.4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 4.6'
x264 --psy-rd 4.6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 4.8'
x264 --psy-rd 4.8 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 5.0'
x264 --psy-rd 5.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qblur 0.2'
x264 --qblur 0.2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qblur 0.3'
x264 --qblur 0.3 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qblur 0.4'
x264 --qblur 0.4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qblur 0.5'
x264 --qblur 0.5 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qblur 0.6'
x264 --qblur 0.6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qcomp 0.6'
x264 --qcomp 0.6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qcomp 0.7'
x264 --qcomp 0.7 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qcomp 0.8'
x264 --qcomp 0.8 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qcomp 0.9'
x264 --qcomp 0.9 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.0'
x264 --vbv-init 0.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.1'
x264 --vbv-init 0.1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.2'
x264 --vbv-init 0.2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.3'
x264 --vbv-init 0.3 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.4'
x264 --vbv-init 0.4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.5'
x264 --vbv-init 0.5 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.6'
x264 --vbv-init 0.6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.7'
x264 --vbv-init 0.7 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.8'
x264 --vbv-init 0.8 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.9'
x264 --vbv-init 0.9 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-mode 0'
x264 --aq-mode 0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-mode 1'
x264 --aq-mode 1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-mode 2'
x264 --aq-mode 2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-mode 3'
x264 --aq-mode 3 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--b-adapt 0'
x264 --b-adapt 0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--b-adapt 1'
x264 --b-adapt 1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--b-adapt 2'
x264 --b-adapt 2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--bframes 0'
x264 --bframes 0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--bframes 2'
x264 --bframes 2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--bframes 4'
x264 --bframes 4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--bframes 6'
x264 --bframes 6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--bframes 8'
x264 --bframes 8 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--bframes 10'
x264 --bframes 10 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--bframes 12'
x264 --bframes 12 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--bframes 14'
x264 --bframes 14 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--bframes 16'
x264 --bframes 16 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 0'
x264 --crf 0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 5'
x264 --crf 5 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 10'
x264 --crf 10 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 15'
x264 --crf 15 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 20'
x264 --crf 20 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 25'
x264 --crf 25 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 30'
x264 --crf 30 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 35'
x264 --crf 35 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 40'
x264 --crf 40 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 45'
x264 --crf 45 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 50'
x264 --crf 50 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 200'
x264 --keyint 200 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 210'
x264 --keyint 210 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 220'
x264 --keyint 220 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 230'
x264 --keyint 230 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 240'
x264 --keyint 240 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 250'
x264 --keyint 250 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 260'
x264 --keyint 260 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 270'
x264 --keyint 270 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 280'
x264 --keyint 280 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 290'
x264 --keyint 290 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 300'
x264 --keyint 300 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--lookahead-threads 0'
x264 --lookahead-threads 0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--lookahead-threads 1'
x264 --lookahead-threads 1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--lookahead-threads 2'
x264 --lookahead-threads 2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--lookahead-threads 3'
x264 --lookahead-threads 3 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--lookahead-threads 4'
x264 --lookahead-threads 4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 20'
x264 --min-keyint 20 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 21'
x264 --min-keyint 21 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 22'
x264 --min-keyint 22 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 23'
x264 --min-keyint 23 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 24'
x264 --min-keyint 24 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 25'
x264 --min-keyint 25 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 26'
x264 --min-keyint 26 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 27'
x264 --min-keyint 27 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 28'
x264 --min-keyint 28 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 29'
x264 --min-keyint 29 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 30'
x264 --min-keyint 30 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qp 0'
x264 --qp 0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qp 10'
x264 --qp 10 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qp 20'
x264 --qp 20 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qp 30'
x264 --qp 30 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qp 40'
x264 --qp 40 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qp 50'
x264 --qp 50 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpstep 3'
x264 --qpstep 3 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpstep 4'
x264 --qpstep 4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpstep 5'
x264 --qpstep 5 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmin 0'
x264 --qpmin 0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmin 1'
x264 --qpmin 1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmin 2'
x264 --qpmin 2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmin 3'
x264 --qpmin 3 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmin 4'
x264 --qpmin 4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 60'
x264 --qpmax 60 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 61'
x264 --qpmax 61 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 62'
x264 --qpmax 62 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 63'
x264 --qpmax 63 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 64'
x264 --qpmax 64 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 65'
x264 --qpmax 65 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 66'
x264 --qpmax 66 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 67'
x264 --qpmax 67 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 68'
x264 --qpmax 68 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 69'
x264 --qpmax 69 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--rc-lookahead 18'
x264 --rc-lookahead 18 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--rc-lookahead 28'
x264 --rc-lookahead 28 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--rc-lookahead 38'
x264 --rc-lookahead 38 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--rc-lookahead 48'
x264 --rc-lookahead 48 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ref 1'
x264 --ref 1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ref 2'
x264 --ref 2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ref 3'
x264 --ref 3 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ref 4'
x264 --ref 4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ref 5'
x264 --ref 5 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ref 6'
x264 --ref 6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-bufsize 1000'
x264 --vbv-bufsize 1000 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-bufsize 2000'
x264 --vbv-bufsize 2000 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--deblock -2:-2'
x264 --deblock -2:-2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--deblock -1:-1'
x264 --deblock -1:-1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--deblock 1:1'
x264 --deblock 1:1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--me dia'
x264 --me dia --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--me hex'
x264 --me hex --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--me umh'
x264 --me umh --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--overscan show'
x264 --overscan show --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--overscan crop'
x264 --overscan crop --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset ultrafast'
x264 --preset ultrafast --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset superfast'
x264 --preset superfast --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset veryfast'
x264 --preset veryfast --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset faster'
x264 --preset faster --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset fast'
x264 --preset fast --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset medium'
x264 --preset medium --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset slow'
x264 --preset slow --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset slower'
x264 --preset slower --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset veryslow'
x264 --preset veryslow --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset placebo'
x264 --preset placebo --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--scenecut 0'
x264 --scenecut 0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--scenecut 10'
x264 --scenecut 10 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--scenecut 30'
x264 --scenecut 30 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--scenecut 40'
x264 --scenecut 40 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--tune psnr'
x264 --tune psnr --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--tune ssim'
x264 --tune ssim --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--tune grain'
x264 --tune grain --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--tune animation'
x264 --tune animation --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-strength 0.0'
x265 --aq-strength 0.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-strength 0.5'
x265 --aq-strength 0.5 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-strength 1.0'
x265 --aq-strength 1.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-strength 1.5'
x265 --aq-strength 1.5 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-strength 2.0'
x265 --aq-strength 2.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-strength 2.5'
x265 --aq-strength 2.5 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-strength 3.0'
x265 --aq-strength 3.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ipratio 1.0'
x265 --ipratio 1.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ipratio 1.1'
x265 --ipratio 1.1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ipratio 1.2'
x265 --ipratio 1.2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ipratio 1.3'
x265 --ipratio 1.3 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ipratio 1.4'
x265 --ipratio 1.4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ipratio 1.5'
x265 --ipratio 1.5 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ipratio 1.6'
x265 --ipratio 1.6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--pbratio 1.0'
x265 --pbratio 1.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--pbratio 1.1'
x265 --pbratio 1.1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--pbratio 1.2'
x265 --pbratio 1.2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--pbratio 1.3'
x265 --pbratio 1.3 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--pbratio 1.4'
x265 --pbratio 1.4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 0.2'
x265 --psy-rd 0.2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 0.4'
x265 --psy-rd 0.4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 0.6'
x265 --psy-rd 0.6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 0.8'
x265 --psy-rd 0.8 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 1.0'
x265 --psy-rd 1.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 1.2'
x265 --psy-rd 1.2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 1.4'
x265 --psy-rd 1.4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 1.6'
x265 --psy-rd 1.6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 1.8'
x265 --psy-rd 1.8 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 2.0'
x265 --psy-rd 2.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 2.2'
x265 --psy-rd 2.2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 2.4'
x265 --psy-rd 2.4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 2.6'
x265 --psy-rd 2.6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 2.8'
x265 --psy-rd 2.8 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 3.0'
x265 --psy-rd 3.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 3.2'
x265 --psy-rd 3.2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 3.4'
x265 --psy-rd 3.4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 3.6'
x265 --psy-rd 3.6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 3.8'
x265 --psy-rd 3.8 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 4.0'
x265 --psy-rd 4.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 4.2'
x265 --psy-rd 4.2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 4.4'
x265 --psy-rd 4.4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 4.6'
x265 --psy-rd 4.6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 4.8'
x265 --psy-rd 4.8 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--psy-rd 5.0'
x265 --psy-rd 5.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qblur 0.2'
x265 --qblur 0.2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qblur 0.3'
x265 --qblur 0.3 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qblur 0.4'
x265 --qblur 0.4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qblur 0.5'
x265 --qblur 0.5 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qblur 0.6'
x265 --qblur 0.6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qcomp 0.6'
x265 --qcomp 0.6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qcomp 0.7'
x265 --qcomp 0.7 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qcomp 0.8'
x265 --qcomp 0.8 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qcomp 0.9'
x265 --qcomp 0.9 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.0'
x265 --vbv-init 0.0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.1'
x265 --vbv-init 0.1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.2'
x265 --vbv-init 0.2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.3'
x265 --vbv-init 0.3 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.4'
x265 --vbv-init 0.4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.5'
x265 --vbv-init 0.5 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.6'
x265 --vbv-init 0.6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.7'
x265 --vbv-init 0.7 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.8'
x265 --vbv-init 0.8 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-init 0.9'
x265 --vbv-init 0.9 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-mode 0'
x265 --aq-mode 0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-mode 1'
x265 --aq-mode 1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-mode 2'
x265 --aq-mode 2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--aq-mode 3'
x265 --aq-mode 3 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--b-adapt 0'
x265 --b-adapt 0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--b-adapt 1'
x265 --b-adapt 1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--b-adapt 2'
x265 --b-adapt 2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--bframes 0'
x265 --bframes 0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--bframes 2'
x265 --bframes 2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--bframes 4'
x265 --bframes 4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--bframes 6'
x265 --bframes 6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--bframes 8'
x265 --bframes 8 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--bframes 10'
x265 --bframes 10 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--bframes 12'
x265 --bframes 12 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--bframes 14'
x265 --bframes 14 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--bframes 16'
x265 --bframes 16 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 0'
x265 --crf 0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 5'
x265 --crf 5 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 10'
x265 --crf 10 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 15'
x265 --crf 15 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 20'
x265 --crf 20 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 25'
x265 --crf 25 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 30'
x265 --crf 30 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 35'
x265 --crf 35 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 40'
x265 --crf 40 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 45'
x265 --crf 45 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--crf 50'
x265 --crf 50 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 200'
x265 --keyint 200 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 210'
x265 --keyint 210 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 220'
x265 --keyint 220 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 230'
x265 --keyint 230 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 240'
x265 --keyint 240 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 250'
x265 --keyint 250 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 260'
x265 --keyint 260 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 270'
x265 --keyint 270 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 280'
x265 --keyint 280 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 290'
x265 --keyint 290 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--keyint 300'
x265 --keyint 300 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--lookahead-threads 0'
x265 --lookahead-threads 0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--lookahead-threads 1'
x265 --lookahead-threads 1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--lookahead-threads 2'
x265 --lookahead-threads 2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--lookahead-threads 3'
x265 --lookahead-threads 3 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--lookahead-threads 4'
x265 --lookahead-threads 4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 20'
x265 --min-keyint 20 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 21'
x265 --min-keyint 21 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 22'
x265 --min-keyint 22 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 23'
x265 --min-keyint 23 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 24'
x265 --min-keyint 24 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 25'
x265 --min-keyint 25 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 26'
x265 --min-keyint 26 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 27'
x265 --min-keyint 27 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 28'
x265 --min-keyint 28 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 29'
x265 --min-keyint 29 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--min-keyint 30'
x265 --min-keyint 30 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qp 0'
x265 --qp 0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qp 10'
x265 --qp 10 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qp 20'
x265 --qp 20 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qp 30'
x265 --qp 30 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qp 40'
x265 --qp 40 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qp 50'
x265 --qp 50 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpstep 3'
x265 --qpstep 3 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpstep 4'
x265 --qpstep 4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpstep 5'
x265 --qpstep 5 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmin 0'
x265 --qpmin 0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmin 1'
x265 --qpmin 1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmin 2'
x265 --qpmin 2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmin 3'
x265 --qpmin 3 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmin 4'
x265 --qpmin 4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 60'
x265 --qpmax 60 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 61'
x265 --qpmax 61 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 62'
x265 --qpmax 62 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 63'
x265 --qpmax 63 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 64'
x265 --qpmax 64 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 65'
x265 --qpmax 65 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 66'
x265 --qpmax 66 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 67'
x265 --qpmax 67 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 68'
x265 --qpmax 68 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--qpmax 69'
x265 --qpmax 69 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--rc-lookahead 18'
x265 --rc-lookahead 18 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--rc-lookahead 28'
x265 --rc-lookahead 28 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--rc-lookahead 38'
x265 --rc-lookahead 38 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--rc-lookahead 48'
x265 --rc-lookahead 48 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ref 1'
x265 --ref 1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ref 2'
x265 --ref 2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ref 3'
x265 --ref 3 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ref 4'
x265 --ref 4 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ref 5'
x265 --ref 5 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--ref 6'
x265 --ref 6 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-bufsize 1000'
x265 --vbv-bufsize 1000 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--vbv-bufsize 2000'
x265 --vbv-bufsize 2000 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--deblock -2:-2'
x265 --deblock -2:-2 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--deblock -1:-1'
x265 --deblock -1:-1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--deblock 1:1'
x265 --deblock 1:1 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--me dia'
x265 --me dia --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--me hex'
x265 --me hex --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--me umh'
x265 --me umh --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--overscan show'
x265 --overscan show --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--overscan crop'
x265 --overscan crop --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset ultrafast'
x265 --preset ultrafast --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset superfast'
x265 --preset superfast --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset veryfast'
x265 --preset veryfast --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset faster'
x265 --preset faster --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset fast'
x265 --preset fast --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset medium'
x265 --preset medium --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset slow'
x265 --preset slow --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset slower'
x265 --preset slower --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset veryslow'
x265 --preset veryslow --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--preset placebo'
x265 --preset placebo --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--scenecut 0'
x265 --scenecut 0 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--scenecut 10'
x265 --scenecut 10 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--scenecut 30'
x265 --scenecut 30 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--scenecut 40'
x265 --scenecut 40 --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--tune psnr'
x265 --tune psnr --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--tune ssim'
x265 --tune ssim --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--tune grain'
x265 --tune grain --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo '--tune animation'
x265 --tune animation --input-res 640x360 --fps 6 -o test.mp4 ./inputs/original_videos_LyricVideo_360P_LyricVideo_360P-5e87.mkv
echo 'END ARGUMENTS OPTIONS'
