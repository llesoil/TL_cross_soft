#!/bin/sh

numb='2379'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 1.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 15 --keyint 210 --lookahead-threads 4 --min-keyint 21 --qp 0 --qpstep 4 --qpmin 3 --qpmax 62 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset veryfast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.5,1.5,1.1,1.0,0.3,0.7,0.4,0,0,12,15,210,4,21,0,4,3,62,38,2,2000,-1:-1,hex,show,veryfast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"