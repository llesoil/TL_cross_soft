#!/bin/sh

numb='29'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 3.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.6 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 25 --keyint 230 --lookahead-threads 2 --min-keyint 30 --qp 50 --qpstep 4 --qpmin 2 --qpmax 65 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset ultrafast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,1.0,1.5,1.2,3.6,0.2,0.8,0.6,3,1,12,25,230,2,30,50,4,2,65,38,1,1000,-2:-2,dia,show,ultrafast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"