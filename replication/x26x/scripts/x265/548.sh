#!/bin/sh

numb='549'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --intra-refresh --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 4.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 16 --crf 50 --keyint 220 --lookahead-threads 4 --min-keyint 22 --qp 40 --qpstep 5 --qpmin 0 --qpmax 68 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset placebo --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,--intra-refresh,--no-asm,None,--no-weightb,0.0,1.4,1.2,4.2,0.3,0.8,0.4,0,2,16,50,220,4,22,40,5,0,68,28,1,2000,-2:-2,umh,crop,placebo,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"