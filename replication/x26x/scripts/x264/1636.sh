#!/bin/sh

numb='1637'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.3 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 50 --keyint 280 --lookahead-threads 3 --min-keyint 20 --qp 20 --qpstep 5 --qpmin 3 --qpmax 62 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset placebo --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.3,1.0,4.4,0.3,0.6,0.3,3,0,10,50,280,3,20,20,5,3,62,38,3,2000,1:1,umh,show,placebo,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"