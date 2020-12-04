#!/bin/sh

numb='2289'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --intra-refresh --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 4.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.9 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 10 --keyint 250 --lookahead-threads 0 --min-keyint 23 --qp 50 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset slow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,--intra-refresh,--no-asm,None,--no-weightb,0.5,1.4,1.0,4.4,0.6,0.7,0.9,2,0,12,10,250,0,23,50,5,4,63,38,1,1000,-2:-2,dia,show,slow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"