#!/bin/sh

numb='1980'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 4.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.2 --aq-mode 3 --b-adapt 1 --bframes 16 --crf 5 --keyint 270 --lookahead-threads 0 --min-keyint 26 --qp 40 --qpstep 5 --qpmin 0 --qpmax 63 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset placebo --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.6,1.4,4.4,0.6,0.6,0.2,3,1,16,5,270,0,26,40,5,0,63,18,4,2000,-2:-2,dia,show,placebo,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"