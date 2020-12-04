#!/bin/sh

numb='837'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.4 --psy-rd 1.4 --qblur 0.6 --qcomp 0.8 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 10 --crf 0 --keyint 230 --lookahead-threads 4 --min-keyint 30 --qp 40 --qpstep 4 --qpmin 1 --qpmax 63 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset placebo --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,2.0,1.6,1.4,1.4,0.6,0.8,0.6,2,1,10,0,230,4,30,40,4,1,63,18,2,2000,-1:-1,hex,show,placebo,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"