#!/bin/sh

numb='2063'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 1.4 --qblur 0.5 --qcomp 0.8 --vbv-init 0.5 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 40 --keyint 230 --lookahead-threads 4 --min-keyint 27 --qp 30 --qpstep 3 --qpmin 1 --qpmax 69 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset placebo --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,3.0,1.5,1.1,1.4,0.5,0.8,0.5,0,1,10,40,230,4,27,30,3,1,69,38,6,1000,-1:-1,umh,show,placebo,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"