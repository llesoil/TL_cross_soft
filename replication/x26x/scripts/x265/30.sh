#!/bin/sh

numb='31'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 0.6 --qblur 0.3 --qcomp 0.7 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 20 --keyint 210 --lookahead-threads 3 --min-keyint 29 --qp 10 --qpstep 4 --qpmin 2 --qpmax 66 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset ultrafast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,0.0,1.1,1.4,0.6,0.3,0.7,0.1,2,1,10,20,210,3,29,10,4,2,66,48,4,2000,-2:-2,hex,show,ultrafast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"