#!/bin/sh

numb='2046'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 0.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 10 --keyint 210 --lookahead-threads 4 --min-keyint 20 --qp 20 --qpstep 5 --qpmin 3 --qpmax 67 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset placebo --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,3.0,1.5,1.2,0.4,0.5,0.6,0.1,2,0,16,10,210,4,20,20,5,3,67,18,3,2000,1:1,umh,show,placebo,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"