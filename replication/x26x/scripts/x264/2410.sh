#!/bin/sh

numb='2411'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 3.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 15 --keyint 290 --lookahead-threads 0 --min-keyint 30 --qp 30 --qpstep 4 --qpmin 1 --qpmax 64 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset placebo --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.5,1.3,1.1,3.8,0.2,0.7,0.7,2,2,0,15,290,0,30,30,4,1,64,48,4,2000,1:1,hex,show,placebo,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"