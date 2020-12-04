#!/bin/sh

numb='1352'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 5.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 2 --bframes 14 --crf 40 --keyint 290 --lookahead-threads 1 --min-keyint 26 --qp 20 --qpstep 4 --qpmin 4 --qpmax 64 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset placebo --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.5,1.0,5.0,0.2,0.6,0.1,0,2,14,40,290,1,26,20,4,4,64,38,5,1000,-2:-2,umh,show,placebo,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"