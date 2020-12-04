#!/bin/sh

numb='1932'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 2.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.8 --aq-mode 0 --b-adapt 1 --bframes 0 --crf 15 --keyint 250 --lookahead-threads 0 --min-keyint 30 --qp 0 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset ultrafast --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,3.0,1.1,1.4,2.0,0.5,0.6,0.8,0,1,0,15,250,0,30,0,5,4,63,28,4,2000,-2:-2,hex,crop,ultrafast,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"