#!/bin/sh

numb='2733'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 2.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.9 --aq-mode 3 --b-adapt 1 --bframes 0 --crf 5 --keyint 270 --lookahead-threads 3 --min-keyint 25 --qp 10 --qpstep 4 --qpmin 0 --qpmax 64 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,0.0,1.1,1.2,2.4,0.2,0.9,0.9,3,1,0,5,270,3,25,10,4,0,64,28,2,2000,-2:-2,dia,crop,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"