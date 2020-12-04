#!/bin/sh

numb='127'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 1.2 --qblur 0.2 --qcomp 0.6 --vbv-init 0.4 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 30 --keyint 210 --lookahead-threads 4 --min-keyint 25 --qp 10 --qpstep 5 --qpmin 2 --qpmax 63 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset placebo --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,2.0,1.5,1.2,1.2,0.2,0.6,0.4,2,1,16,30,210,4,25,10,5,2,63,18,1,2000,-2:-2,umh,crop,placebo,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"