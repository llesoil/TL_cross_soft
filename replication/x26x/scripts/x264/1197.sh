#!/bin/sh

numb='1198'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 1.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 12 --crf 5 --keyint 260 --lookahead-threads 3 --min-keyint 21 --qp 40 --qpstep 4 --qpmin 4 --qpmax 68 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset placebo --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.3,1.1,1.4,0.6,0.6,0.3,3,1,12,5,260,3,21,40,4,4,68,28,5,1000,-2:-2,hex,crop,placebo,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"