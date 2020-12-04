#!/bin/sh

numb='1053'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 2.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.2 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 5 --keyint 210 --lookahead-threads 0 --min-keyint 27 --qp 10 --qpstep 5 --qpmin 0 --qpmax 67 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset placebo --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.4,1.0,2.4,0.3,0.6,0.2,3,1,8,5,210,0,27,10,5,0,67,18,6,2000,-1:-1,hex,crop,placebo,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"