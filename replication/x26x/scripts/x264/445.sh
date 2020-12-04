#!/bin/sh

numb='446'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 1.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.8 --aq-mode 1 --b-adapt 2 --bframes 4 --crf 10 --keyint 220 --lookahead-threads 1 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.0,1.0,1.0,0.5,0.7,0.8,1,2,4,10,220,1,28,50,4,0,62,38,4,1000,-1:-1,dia,show,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"