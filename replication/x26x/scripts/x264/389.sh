#!/bin/sh

numb='390'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.8 --qblur 0.6 --qcomp 0.6 --vbv-init 0.0 --aq-mode 1 --b-adapt 0 --bframes 8 --crf 35 --keyint 290 --lookahead-threads 3 --min-keyint 20 --qp 10 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset slow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.0,1.3,4.8,0.6,0.6,0.0,1,0,8,35,290,3,20,10,4,2,63,28,6,2000,-2:-2,dia,crop,slow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"