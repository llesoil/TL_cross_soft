#!/bin/sh

numb='2962'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --intra-refresh --no-asm --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 4.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 0 --keyint 260 --lookahead-threads 4 --min-keyint 30 --qp 30 --qpstep 5 --qpmin 4 --qpmax 69 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset placebo --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,--intra-refresh,--no-asm,None,--weightb,3.0,1.2,1.1,4.6,0.3,0.9,0.1,1,1,4,0,260,4,30,30,5,4,69,38,1,2000,1:1,dia,show,placebo,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"