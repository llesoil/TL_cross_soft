#!/bin/sh

numb='885'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.0 --psy-rd 2.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.6 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 0 --keyint 230 --lookahead-threads 1 --min-keyint 29 --qp 50 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 18 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.2,1.0,2.8,0.2,0.7,0.6,1,2,8,0,230,1,29,50,4,2,67,18,2,1000,-1:-1,hex,crop,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"