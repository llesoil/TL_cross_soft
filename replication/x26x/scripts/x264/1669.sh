#!/bin/sh

numb='1670'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 0 --crf 0 --keyint 290 --lookahead-threads 4 --min-keyint 27 --qp 40 --qpstep 4 --qpmin 1 --qpmax 66 --rc-lookahead 48 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset slower --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.0,1.0,1.3,4.4,0.5,0.9,0.0,3,2,0,0,290,4,27,40,4,1,66,48,5,1000,-2:-2,umh,crop,slower,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"