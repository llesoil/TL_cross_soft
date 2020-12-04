#!/bin/sh

numb='2518'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --intra-refresh --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 4 --crf 15 --keyint 270 --lookahead-threads 0 --min-keyint 24 --qp 40 --qpstep 3 --qpmin 2 --qpmax 62 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset veryfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,--intra-refresh,--no-asm,None,--no-weightb,1.0,1.0,1.3,4.4,0.4,0.8,0.5,0,2,4,15,270,0,24,40,3,2,62,38,1,1000,1:1,dia,show,veryfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"