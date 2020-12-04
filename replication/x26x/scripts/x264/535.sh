#!/bin/sh

numb='536'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 1.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 45 --keyint 220 --lookahead-threads 4 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 1 --qpmax 62 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset placebo --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.6,1.0,1.6,0.2,0.8,0.7,1,0,16,45,220,4,30,50,3,1,62,48,3,2000,-1:-1,umh,crop,placebo,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"