#!/bin/sh

numb='393'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 1.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.2 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 45 --keyint 300 --lookahead-threads 4 --min-keyint 22 --qp 50 --qpstep 4 --qpmin 1 --qpmax 64 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset placebo --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.4,1.2,1.0,0.5,0.8,0.2,1,0,4,45,300,4,22,50,4,1,64,28,4,1000,1:1,dia,show,placebo,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"