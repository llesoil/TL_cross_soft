#!/bin/sh

numb='1993'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 4.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 16 --crf 25 --keyint 230 --lookahead-threads 4 --min-keyint 21 --qp 30 --qpstep 5 --qpmin 4 --qpmax 62 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset veryfast --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,3.0,1.5,1.1,4.4,0.5,0.7,0.8,1,1,16,25,230,4,21,30,5,4,62,38,3,2000,-2:-2,umh,crop,veryfast,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"