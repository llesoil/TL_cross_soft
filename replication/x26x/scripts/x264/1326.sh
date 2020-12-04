#!/bin/sh

numb='1327'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 0.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.3 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 25 --keyint 300 --lookahead-threads 2 --min-keyint 24 --qp 20 --qpstep 3 --qpmin 2 --qpmax 60 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset placebo --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--weightb,2.0,1.0,1.2,0.4,0.4,0.7,0.3,2,0,14,25,300,2,24,20,3,2,60,48,6,1000,-1:-1,dia,show,placebo,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"