#!/bin/sh

numb='460'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 3.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.9 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 10 --keyint 290 --lookahead-threads 4 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 3 --qpmax 67 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset placebo --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.4,1.3,3.6,0.3,0.8,0.9,2,2,4,10,290,4,30,40,3,3,67,48,4,1000,-1:-1,dia,crop,placebo,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"